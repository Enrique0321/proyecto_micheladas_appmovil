const express = require('express');
const cors = require('cors');
const app = express();
const port = 3000;

app.use (cors());

app.get('/', (req, res) => {
  res.send('¡Hola mundo!');
});



// Datos de ejemplo
const comida = [
    {id : 1, titulo: "Super mentadads micheladas", cocine : "Enrique Carranza"},
    {id : 2, titulo: "Micheladas", cocine : "Juan Perez"},
    {id : 3, titulo: "Michepache", cocine : "Pablos Carranza"},
    ]

    app.get ("/api/comida", (req, res) => {
        res.json (comida);
    }
);

app.listen(port, () => {
  console.log(`Servidor ejecutándose en http://localhost:${port}`);
});


