const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const port = 3306;

const app = express();

app.use(cors());
app.use(bodyParser.json());

// CONFIGURACIÓN DE LA CONEXIÓN A MYSQL (Workbench)
const db = mysql.createConnection({
    // CONFIGURACIÓN DE LA CONEXIÓN A MYSQL
    host: '127.0.0.1',      
    port: 3306,             
    user: 'root',           
    password: '', // 
    database: 'micheladas_app'   // Asegúrate de que este SCHEMA exista en Workbench
});


// Probar conexión
db.connect(err => {
    if (err) {
        console.log('❌ Error al conectar a MySQL:', err);
        return;
    }
    console.log('✅ Conectado a la base de datos MySQL');
});

// Ruta de prueba
app.get('/', (req, res) => {
    res.send('Servidor funcionando y conectado a MySQL');
});


// Ruta de registro de usuario
app.post('/register', (req, res) => {
    const { nombre, apellidos, email, telefono, password } = req.body;
    const sql = "INSERT INTO users (nombre,apellidos, email, telefono, password ) VALUES (?, ?, ?)";
    db.query(sql, [name, email, password], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err });
        }
        res.json({ ok: true, message: 'Usuario registrado exitosamente' });
    });
});


// Ruta de login de usuario



app.post("/login", (req, res) => {
  const { email, password } = req.body;

  db.query(
    "SELECT * FROM users WHERE email = ? AND password = ?",
    [email, password],
    (err, result) => {
      if (err) {
        return res.status(500).json({ error: err });
      }

      if (result.length > 0) {
        res.json({ ok: true, user: result[0] });
      } else {
        res.json({ ok: false, message: "Credenciales incorrectas" });
      }
    }
  );
});




// Iniciar servidor
app.listen(3000, () => {
    console.log('Servidor iniciado en http://localhost:3000');
});




