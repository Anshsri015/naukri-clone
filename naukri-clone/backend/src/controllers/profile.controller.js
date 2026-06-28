const db = require('../db/database');

const saveProfile = (req, res) => {
  const userId = req.user.id;
  const { degree, cgpa, experience_type, job_field } = req.body;

  if (!degree || !experience_type || !job_field) {
    return res.status(400).json({ message: 'Degree, experience and job field are required' });
  }

  const existing = db.prepare('SELECT id FROM profiles WHERE user_id = ?').get(userId);

  if (existing) {
    db.prepare(`
      UPDATE profiles SET degree=?, cgpa=?, experience_type=?, job_field=?
      WHERE user_id=?
    `).run(degree, cgpa || null, experience_type, job_field, userId);
  } else {
    db.prepare(`
      INSERT INTO profiles (user_id, degree, cgpa, experience_type, job_field)
      VALUES (?, ?, ?, ?, ?)
    `).run(userId, degree, cgpa || null, experience_type, job_field);
  }

  res.json({ message: 'Profile saved successfully!' });
};

const getProfile = (req, res) => {
  const userId = req.user.id;
  const profile = db.prepare('SELECT * FROM profiles WHERE user_id = ?').get(userId);

  if (!profile) {
    return res.status(404).json({ message: 'Profile not found' });
  }

  res.json(profile);
};

module.exports = { saveProfile, getProfile };