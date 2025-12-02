import { jest } from "@jest/globals";
import request from "supertest";

// --- 🔥 MOCK explícito del módulo db.js ---
jest.unstable_mockModule("../src/db.js", () => ({
  default: {
    query: jest.fn()
  }
}));

// --- 🔥 Importar luego de definir el mock ---
const app = (await import("../src/server.js")).default;
const pool = (await import("../src/db.js")).default;

describe("API MySQL Tests", () => {

  test("GET /api/usuarios debería devolver una lista", async () => {

    const mockData = [
      { id: 1, nombre: "Kelvin", email: "kelvin@kdvops.com" },
      { id: 2, nombre: "Maria", email: "maria@mail.com" }
    ];

    pool.query.mockResolvedValue([mockData]);

    const res = await request(app).get("/api/usuarios");

    expect(res.statusCode).toBe(200);
    expect(res.body.length).toBe(2);
    expect(res.body[0].nombre).toBe("Kelvin");
  });


  test("GET /api/usuarios/1 devuelve un usuario", async () => {

    const mockUser = [
      { id: 1, nombre: "Kelvin", email: "kelvin@kdvops.com" }
    ];

    pool.query.mockResolvedValue([mockUser]);

    const res = await request(app).get("/api/usuarios/1");

    expect(res.statusCode).toBe(200);
    expect(res.body.email).toBe("kelvin@kdvops.com");
  });


  test("GET /api/usuarios/99 retorna 404", async () => {

    pool.query.mockResolvedValue([[]]);

    const res = await request(app).get("/api/usuarios/99");

    expect(res.statusCode).toBe(404);
    expect(res.body.message).toBe("Usuario no encontrado");
  });

});
