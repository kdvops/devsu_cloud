import { Router } from 'express';
import pool from './db.js';

const router = Router();

// GET todos los usuarios
router.get('/usuarios', async (req, res) => {
    try {
        const [rows] = await pool.query("SELECT * FROM usuarios");
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// GET usuario por id
router.get('/usuarios/:id', async (req, res) => {
    try {
        const [rows] = await pool.query(
            "SELECT * FROM usuarios WHERE id = ?",
            [req.params.id]
        );

        if (rows.length === 0)
            return res.status(404).json({ message: "Usuario no encontrado" });

        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

export default router;
