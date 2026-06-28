const db = require('../db/database');

const getAllJobs = (req, res) => {
  const { search, location } = req.query;

  let query = 'SELECT * FROM jobs';
  const params = [];

  if (search && location) {
    query += ' WHERE (title LIKE ? OR company LIKE ?) AND location LIKE ?';
    params.push(`%${search}%`, `%${search}%`, `%${location}%`);
  } else if (search) {
    query += ' WHERE title LIKE ? OR company LIKE ?';
    params.push(`%${search}%`, `%${search}%`);
  } else if (location) {
    query += ' WHERE location LIKE ?';
    params.push(`%${location}%`);
  }

  query += ' ORDER BY posted_on DESC';

  const jobs = db.prepare(query).all(...params);

  const formattedJobs = jobs.map(job => ({
    ...job,
    skills: JSON.parse(job.skills || '[]'),
  }));

  res.json(formattedJobs);
};

const getJobById = (req, res) => {
  const job = db.prepare('SELECT * FROM jobs WHERE id = ?').get(req.params.id);

  if (!job) {
    return res.status(404).json({ message: 'Job not found' });
  }

  res.json({
    ...job,
    skills: JSON.parse(job.skills || '[]'),
  });
};

const createJob = (req, res) => {
  const { title, company, location, salary, experience, type, description, skills } = req.body;

  if (!title || !company || !location || !salary || !experience || !type) {
    return res.status(400).json({ message: 'All required fields must be filled' });
  }

  const result = db.prepare(`
    INSERT INTO jobs (title, company, location, salary, experience, type, description, skills)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `).run(
    title, company, location, salary, experience, type,
    description || '',
    JSON.stringify(skills || [])
  );

  const newJob = db.prepare('SELECT * FROM jobs WHERE id = ?').get(result.lastInsertRowid);

  res.status(201).json({
    ...newJob,
    skills: JSON.parse(newJob.skills || '[]'),
  });
};

const updateJob = (req, res) => {
  const job = db.prepare('SELECT * FROM jobs WHERE id = ?').get(req.params.id);

  if (!job) {
    return res.status(404).json({ message: 'Job not found' });
  }

  const {
    title = job.title,
    company = job.company,
    location = job.location,
    salary = job.salary,
    experience = job.experience,
    type = job.type,
    description = job.description,
    skills = JSON.parse(job.skills || '[]'),
  } = req.body;

  db.prepare(`
    UPDATE jobs SET title=?, company=?, location=?, salary=?, experience=?, type=?, description=?, skills=?
    WHERE id=?
  `).run(title, company, location, salary, experience, type, description, JSON.stringify(skills), req.params.id);

  const updatedJob = db.prepare('SELECT * FROM jobs WHERE id = ?').get(req.params.id);

  res.json({
    ...updatedJob,
    skills: JSON.parse(updatedJob.skills || '[]'),
  });
};

const deleteJob = (req, res) => {
  const job = db.prepare('SELECT * FROM jobs WHERE id = ?').get(req.params.id);

  if (!job) {
    return res.status(404).json({ message: 'Job not found' });
  }

  db.prepare('DELETE FROM jobs WHERE id = ?').run(req.params.id);

  res.json({ message: 'Job deleted successfully' });
};

module.exports = { getAllJobs, getJobById, createJob, updateJob, deleteJob };