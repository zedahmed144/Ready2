const request = require('supertest');
const express = require('express');

const app = express();
app.get('/', async (req, res) => {
    res.send('Hello, I am an API response!');
});

describe('GET /', () => {
    it('should return a message', async () => {
        const res = await request(app).get('/');
        expect(res.statusCode).toEqual(200);
        expect(res.text).toBe('Hello, I am an API response!');
    });
});
