const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
const port = process.env.PORT || 3000;

const app = express();

app.use(cors());
app.use(bodyParser.json());

// Middleware para manejar JSON malformado
app.use((err, req, res, next) => {
  if (err && err.type === 'entity.parse.failed') {
    return res.status(400).json({ ok: false, error: 'JSON malformado en el body' });
  }
  next(err);
});

// CONFIGURACIÓN DE LA CONEXIÓN A MYSQL (Workbench)
const db = mysql.createConnection({
  // CONFIGURACIÓN DE LA CONEXIÓN A MYSQL
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: 'kiko', // 
  database: 'micheladas_appmovil'   // Asegúrate de que este SCHEMA exista en Workbench
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
  const sql = "INSERT INTO users (nombre, apellidos, email, telefono, password) VALUES (?, ?, ?, ?, ?)";
  db.query(sql, [nombre, apellidos, email, telefono, password], (err, result) => {
    if (err) {
      return res.status(500).json({ ok: false, error: err.message });
    }
    res.json({ ok: true, success: true, message: 'Usuario registrado exitosamente', id: result.insertId });
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
        return res.status(500).json({ ok: false, success: false, error: err.message });
      }

      if (result.length > 0) {
        res.json({ ok: true, success: true, user: result[0], message: 'Login exitoso' });
      } else {
        res.json({ ok: false, success: false, message: "Credenciales incorrectas" });
      }
    }
  );
});




// Iniciar servidor
app.listen(port, () => {
  console.log(`\n✅ Servidor iniciado en http://localhost:${port}\n`);
});




