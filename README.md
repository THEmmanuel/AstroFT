# astroFT 
 a METABOLISM hackthon project 

Astro FT was created by a team of astronomy enthusiasts/stargazers with a shared passion and fascination for the skies.The idea was to have a dynamic NFT that changes to showcase major astronomical events. On days without an astronomical event, we explore the beauty of the universe further by showing the Astronomy Picture Of the Day from NASA. 

## Features

- Uses Tableland to make the nft dynamic to store all audio files. 
- A server to fetch the Image from NASA's API.


## Tech

Astro uses a number of open source projects to work properly:

- [NextJS](https://nextjs.org/) - HTML enhanced for web apps!
- [TableLand](https://tableland.xyz/) - Relational metadata protocol for EVM chains.
- [Lit Protocol](https://litprotocol.com/) - Decentralized Access Control for Web3
- [Ethers](https://docs.ethers.io/v5/) - interacting with the Ethereum Blockchain and its ecosystem.
- [livepeer](https://livepeer.studio/) - the world's open video infrastructure.



## Installation

Before installation make sure you have access to liverpeer api.
- [Streaming with Livepeer Studio](https://docs.livepeer.studio/references/stream/)


### Smart Contract 
Install the dependencies and devDependencies

```sh
cd smart-contracts
npm i
```
create .env file and fill it

```sh
cp .env-example ~/.env
```

compile amd deploy contract
 ```sh
npx hardhat compile
npx hardhat run --network mumbai scripts/deploy.js

```

### comuunity page 

Install the dependencies and devDependencies

```sh
cd AstroFT-Community
npm i
```
run
 ```sh
npm run dev

```