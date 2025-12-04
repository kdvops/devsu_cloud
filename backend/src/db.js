import mysql from 'mysql2/promise';
import dotenv from 'dotenv';
dotenv.config();

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    //host: "#*_{RDS_ENDPOINT_MYSQL}*#",
    //user: "#*_{DB_USER}*#",
    //password: "#*_{DB_PASS}*#",
    //database: "#*{DB_NAME}*#",
    waitForConnections: true,
    connectionLimit: 10
});

export default pool;

