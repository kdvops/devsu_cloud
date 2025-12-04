const API_URL = "#{ALB_DNS_NAME}#/api/usuarios"; 
// Ej: "https://api.kdvops.com/api/usuarios"

async function listarUsuarios() {
    const resultDiv = document.getElementById("result");
    resultDiv.innerHTML = "Cargando...";

    try {
        const res = await fetch(API_URL);
        const data = await res.json();

        if (!Array.isArray(data)) {
            resultDiv.innerHTML = "<p>No se encontraron usuarios.</p>";
            return;
        }

        resultDiv.innerHTML = data
            .map(u => `
                <div class="user">
                    <strong>ID:</strong> ${u.id}<br>
                    <strong>Nombre:</strong> ${u.nombre}<br>
                    <strong>Email:</strong> ${u.email}
                </div>
            `)
            .join("");

    } catch (error) {
        resultDiv.innerHTML = "<p>Error al cargar usuarios.</p>";
    }
}

async function buscarUsuario() {
    const id = document.getElementById("userId").value;
    const resultDiv = document.getElementById("result");

    if (!id) {
        alert("Ingresa un ID");
        return;
    }

    resultDiv.innerHTML = "Buscando...";

    try {
        const res = await fetch(`${API_URL}/${id}`);
        const user = await res.json();

        if (!user.id) {
            resultDiv.innerHTML = "<p>Usuario no encontrado.</p>";
            return;
        }

        resultDiv.innerHTML = `
            <div class="user">
                <strong>ID:</strong> ${user.id}<br>
                <strong>Nombre:</strong> ${user.nombre}<br>
                <strong>Email:</strong> ${user.email}
            </div>
        `;

    } catch (error) {
        resultDiv.innerHTML = "<p>Error al buscar usuario.</p>";
    }
}
