# After-Sales Service DApp

A simple decentralized application (DApp) built with **Solidity, Hardhat, and Web3.js**.  
It allows clients to create service requests, agents to respond, and the contract owner to manage agents and ownership.

## 🚀 Features
- Clients can:
  - Create new service requests
  - Add feedback to their requests
  - List and view their requests
- Agents can:
  - Update requests with status and response
- Owner can:
  - Add new agents
  - Transfer ownership
- Frontend:
  - Simple HTML/JS interface (works with MetaMask)

## 📂 Project Structure
after-sales-dapp/
│── contracts/ # Solidity smart contracts (Lock.sol, AfterSalesService.sol)
│── scripts/ # Deployment scripts
│── test/ # Tests for contracts
│── interface/ # Frontend (index.html with Web3.js)
│── hardhat.config.js # Hardhat configuration
│── package.json # Node.js dependencies
│── README.md # Project documentation

## 🛠 Tech Stack
- **Solidity** – Smart contracts
- **Hardhat** – Development framework
- **Web3.js** – Frontend blockchain interaction
- **MetaMask** – Wallet

## ⚡ Setup & Usage
Clone the repo and install dependencies:
```bash
git clone https://github.com/yamritech-tech/after-sales-dapp.git
cd after-sales-dapp
npm install

Compile the contracts:
npx hardhat compile

Run a local Hardhat blockchain:
npx hardhat node

Deploy the contracts (to localhost):
npx hardhat run scripts/deploy.js --network localhost

Open the frontend:
Go to interface/index.html
Open in your browser
Connect MetaMask (use localhost network)



