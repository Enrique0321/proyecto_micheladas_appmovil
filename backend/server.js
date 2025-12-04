const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');

const port = process.env.PORT || 3000;

const app = express();

app.use(cors());
app.use(bodyParser.json());
require('dotenv').config();
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

app.post('/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
    });

    res.json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});



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
  //password: 'kiko', // 
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

// Ruta para obtener productos
app.get('/products', (req, res) => {
  const sql = "SELECT * FROM products";
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({ ok: false, error: err.message });
    }
    res.json({ ok: true, success: true, products: results });
  });
});

// Crear una orden
app.post('/orders', (req, res) => {
  const { userId, total, items } = req.body; // items es un array de { productId, quantity, price }

  if (!userId || !total || !items || items.length === 0) {
    return res.status(400).json({ ok: false, error: 'Faltan datos' });
  }

  // 1. Insertar en tabla orders (total_amount)
  const sqlOrder = "INSERT INTO orders (user_id, total, status, created_at) VALUES (?, ?, 'Pagado', NOW())";

  db.query(sqlOrder, [userId, total], (err, result) => {
    if (err) {
      console.error("Error inserting order:", err); // Log error
      return res.status(500).json({ ok: false, error: err.message });
    }

    const orderId = result.insertId;

    // 2. Insertar en tabla order_items (product_id)
    const sqlItems = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES ?";
    const values = items.map(item => [orderId, item.productId, item.quantity, item.price]);

    db.query(sqlItems, [values], (err, resultItems) => {
      if (err) {
        console.error("Error inserting order items:", err); // Log error
        return res.status(500).json({ ok: false, error: err.message });
      }
      res.json({ ok: true, success: true, orderId: orderId });
    });
  });
});

// Obtener ordenes de un usuario
app.get('/orders/:user_id', (req, res) => {
  const user_id = req.params.user_id;

  // Obtenemos las ordenes
  const sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

  db.query(sql, [user_id], (err, orders) => {
    if (err) {
      return res.status(500).json({ ok: false, error: err.message });
    }

    if (orders.length === 0) {
      return res.json({ ok: true, success: true, orders: [] });
    }

    const promises = orders.map(order => {
      return new Promise((resolve, reject) => {
        const sqlItems = `
          SELECT oi.*, p.name as product_name 
          FROM order_items oi 
          JOIN products p ON oi.product_id = p.id 
          WHERE oi.order_id = ?
        `;
        db.query(sqlItems, [order.id], (err, items) => {
          if (err) return reject(err);
          order.items = items;
          resolve(order);
        });
      });
    });

    Promise.all(promises)
      .then(completedOrders => {
        res.json({ ok: true, success: true, orders: completedOrders });
      })
      .catch(error => {
        res.status(500).json({ ok: false, error: error.message });
      });
  });
});




// Iniciar servidor
app.listen(port, () => {
  console.log(`\n✅ Servidor iniciado en http://localhost:${port}\n`);
});




