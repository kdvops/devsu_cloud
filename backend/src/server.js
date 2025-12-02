import express from 'express';
import router from './routes.js';
import dotenv from 'dotenv';
import cors from 'cors';         // ← IMPORTAR CORS

dotenv.config();

const app = express();

// HABILITAR CORS
app.use(cors());                 // ← MIDDLEWARE DE CORS

app.use(express.json());

app.use('/api', router);

export default app; // ⬅ necesario para testing

// Solo iniciar servidor si no estamos en test
if (process.env.NODE_ENV !== "test") {
  const PORT = process.env.PORT || 3000;
  app.listen(PORT, () =>
    console.log(`API running on port ${PORT}`)
  );
}
