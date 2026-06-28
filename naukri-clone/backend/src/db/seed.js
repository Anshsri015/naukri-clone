const db = require('./database');

const jobs = [
  {
    title: 'Senior Flutter Developer',
    company: 'Infosys Ltd.',
    location: 'Bangalore, India',
    salary: '12 - 18 LPA',
    experience: '3 - 5 years',
    type: 'Full-time',
    description: 'Looking for an experienced Flutter developer to build cross-platform mobile apps.',
    skills: JSON.stringify(['Flutter', 'Dart', 'Firebase', 'REST APIs']),
  },
  {
    title: 'Backend Engineer (Node.js)',
    company: 'Zomato',
    location: 'Gurugram, India',
    salary: '15 - 22 LPA',
    experience: '2 - 4 years',
    type: 'Full-time',
    description: 'Build and scale backend services for food delivery platform.',
    skills: JSON.stringify(['Node.js', 'MongoDB', 'Redis', 'Docker']),
  },
  {
    title: 'Full Stack Developer',
    company: 'Razorpay',
    location: 'Bangalore, India',
    salary: '18 - 28 LPA',
    experience: '3 - 6 years',
    type: 'Full-time',
    description: 'Work on payment gateway products used by millions.',
    skills: JSON.stringify(['React', 'Node.js', 'PostgreSQL', 'AWS']),
  },
  {
    title: 'Android Developer (Kotlin)',
    company: 'Meesho',
    location: 'Bangalore, India',
    salary: '12 - 17 LPA',
    experience: '2 - 4 years',
    type: 'Full-time',
    description: 'Build and maintain Android app for social commerce platform.',
    skills: JSON.stringify(['Kotlin', 'Jetpack Compose', 'MVVM', 'Retrofit']),
  },
  {
    title: 'React Native Developer',
    company: 'PhonePe',
    location: 'Hyderabad, India',
    salary: '10 - 16 LPA',
    experience: '2 - 4 years',
    type: 'Full-time',
    description: 'Develop cross-platform mobile features for UPI payments app.',
    skills: JSON.stringify(['React Native', 'JavaScript', 'Redux', 'REST APIs']),
  },
  {
    title: 'Data Scientist',
    company: 'CRED',
    location: 'Bangalore, India',
    salary: '20 - 30 LPA',
    experience: '4 - 7 years',
    type: 'Full-time',
    description: 'Build ML models for credit scoring and user behaviour analysis.',
    skills: JSON.stringify(['Python', 'TensorFlow', 'SQL', 'Spark']),
  },
  {
    title: 'DevOps Engineer',
    company: 'Flipkart',
    location: 'Bangalore, India',
    salary: '14 - 20 LPA',
    experience: '3 - 5 years',
    type: 'Full-time',
    description: 'Manage CI/CD pipelines and cloud infrastructure at scale.',
    skills: JSON.stringify(['AWS', 'Kubernetes', 'Docker', 'Terraform']),
  },
  {
    title: 'UI/UX Designer',
    company: 'Swiggy',
    location: 'Remote',
    salary: '8 - 12 LPA',
    experience: '1 - 3 years',
    type: 'Remote',
    description: 'Design intuitive user experiences for food delivery app.',
    skills: JSON.stringify(['Figma', 'Adobe XD', 'Prototyping', 'User Research']),
  },
  {
    title: 'Product Manager',
    company: 'OYO Rooms',
    location: 'Delhi NCR, India',
    salary: '25 - 35 LPA',
    experience: '5 - 8 years',
    type: 'Full-time',
    description: 'Own product roadmap for hotel booking and hospitality platform.',
    skills: JSON.stringify(['Product Strategy', 'Agile', 'Data Analysis', 'Stakeholder Management']),
  },
  {
    title: 'SDE-1 (Fresher Eligible)',
    company: 'Paytm',
    location: 'Noida, India',
    salary: '6 - 10 LPA',
    experience: '0 - 1 year',
    type: 'Full-time',
    description: 'Entry-level software engineering role for fintech products.',
    skills: JSON.stringify(['Java', 'DSA', 'SQL', 'Spring Boot']),
  },
  {
    title: 'ML Engineer',
    company: 'Nykaa',
    location: 'Mumbai, India',
    salary: '16 - 24 LPA',
    experience: '3 - 5 years',
    type: 'Full-time',
    description: 'Build recommendation engine for beauty and fashion e-commerce.',
    skills: JSON.stringify(['Python', 'PyTorch', 'MLflow', 'AWS SageMaker']),
  },
  {
    title: 'Cloud Architect (AWS)',
    company: 'TCS',
    location: 'Pune, India',
    salary: '30 - 45 LPA',
    experience: '7 - 10 years',
    type: 'Full-time',
    description: 'Design and implement cloud solutions for enterprise clients.',
    skills: JSON.stringify(['AWS', 'Azure', 'Solution Architecture', 'Security']),
  },
  {
    title: 'QA Automation Engineer',
    company: "Byju's",
    location: 'Bangalore, India',
    salary: '8 - 14 LPA',
    experience: '2 - 4 years',
    type: 'Full-time',
    description: 'Build automated test suites for EdTech platform.',
    skills: JSON.stringify(['Selenium', 'Appium', 'Java', 'TestNG']),
  },
  {
    title: 'iOS Developer (Swift)',
    company: 'Dream11',
    location: 'Mumbai, India',
    salary: '14 - 20 LPA',
    experience: '3 - 5 years',
    type: 'Full-time',
    description: 'Develop and optimize iOS app for fantasy sports platform.',
    skills: JSON.stringify(['Swift', 'SwiftUI', 'Core Data', 'Xcode']),
  },
  {
    title: 'Intern — Software Engineer',
    company: 'Ola Cabs',
    location: 'Bangalore, India',
    salary: '25 - 35K/month',
    experience: '0 years',
    type: 'Internship',
    description: 'Work on real projects in ride-sharing platform engineering team.',
    skills: JSON.stringify(['Any Language', 'DSA', 'Problem Solving']),
  },
];

// Pehle check karo — agar jobs pehle se hain toh seed mat karo
const existingCount = db.prepare('SELECT COUNT(*) as count FROM jobs').get();

if (existingCount.count === 0) {
  const insert = db.prepare(`
    INSERT INTO jobs (title, company, location, salary, experience, type, description, skills)
    VALUES (@title, @company, @location, @salary, @experience, @type, @description, @skills)
  `);

  // Transaction use karo — Room ke runInTransaction jaisa
  const insertMany = db.transaction((jobList) => {
    for (const job of jobList) {
      insert.run(job);
    }
  });

  insertMany(jobs);
  console.log(`✅ Seed complete — ${jobs.length} jobs inserted`);
} else {
  console.log(`ℹ️  Seed skipped — ${existingCount.count} jobs already exist`);
}