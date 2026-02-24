const express = require('express');
const mongoose = require('mongoose');

const app = express();

// ===== ENV SETTINGS =====
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/testdb';
const ENV = process.env.NODE_ENV || 'dev';

// ===== MONGODB CONNECT =====
mongoose.connect(MONGO_URI, {
  serverSelectionTimeoutMS: 5000
})
.then(() => console.log(`✅ Connected to MongoDB`))
.catch(err => {
  console.error('❌ MongoDB connection error:', err.message);
});

// ===== ROUTES =====
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'Hello from Node.js ECS App!',
    environment: ENV
  });
});

// Health check endpoint for ALB
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

// ===== START SERVER =====
app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 App running on port ${PORT}`);
});
