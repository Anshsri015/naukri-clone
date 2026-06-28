const dotenv = require('dotenv');
dotenv.config();
const express = require('express');
const cors = require('cors');

require('./src/db/database');
require('./src/db/seed');

const authRoutes = require('./src/routes/auth.routes');
const jobsRoutes = require('./src/routes/jobs.routes');
const profileRoutes = require('./src/routes/profile.routes');

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/jobs', jobsRoutes);
app.use('/api/profile', profileRoutes);

app.get('/', (req, res) => {
  res.json({ message: '🚀 Naukri Clone API is running!' });
});

app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});