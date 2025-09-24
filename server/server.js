const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();
const port = 3000;

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',     // MySQL 계정
  password: '0000',
  database: 'buson',
  port: 3400,
});

app.use(cors());

// 연결 확인
db.connect(err => {
  if (err) {
    console.error('MySQL 연결 실패:', err);
    return;
  }
  console.log('MySQL 연결 성공!');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});