const hre = require("hardhat");

async function main() {
  const chatAppFactory = await hre.ethers.getContractFactory("ChatApp");
  const ChatApp = await chatAppFactory.deploy();

  await ChatApp.deployed();

  console.log("Deployed at ", ChatApp.address);
}

main()
  .then(() => {
    console.log("Working properly");
  })
  .catch((error) => {
    console.log(error);
    console.log("Some error occured");
  });
