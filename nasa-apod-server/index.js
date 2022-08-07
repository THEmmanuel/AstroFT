// const axios = require('axios');
import axios from 'axios';
import express from 'express';

const url = "https://api.nasa.gov/planetary/apod?api_key=";
const api_key = "6F5oevHn2pzNGHpLgWR32PrbR2MIn61GdnryrxeP";
let nasaImage = ''
const app = express()
const port = process.env.PORT || 8080

const fetchData = async () => {
	try {
		await axios.get(`${url}${api_key}`)
			.then(res => {
				nasaImage = res.data.url
			})
	} catch (error) {
		console.log(error)
	}
	console.log(nasaImage)
	// return 'hey';
}

fetchData();

// Starts server
app.get('/', (req, res) => {
	res.redirect(nasaImage.toString())
})

app.listen(port, (req, res) => {
	console.log('running at port ' + port);
})
// console.log('nasa image' + nasaImage)