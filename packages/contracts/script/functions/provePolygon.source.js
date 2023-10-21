const tx = args[0];

const url = `https://polygon-mumbai.infura.io/v3/1b4fd85ec53748feae973ece5bc436bd`;

const txInfoRequest = Functions.makeHttpRequest({
  url: url,
  headers: {
    "Content-Type": "application/json",
  },
  method: "POST",
  data: `{"method":"eth_getTransactionReceipt","params":["${tx}"],"id":43,"jsonrpc":"2.0"}`,
});

const txInfoResponse = await txInfoRequest;
if (txInfoResponse.error) {
  console.error(txInfoResponse.error);
  throw Error("Request failed");
}

// Execute the API request (Promise)
const data = txInfoResponse["data"];
if (data.error) {
  console.error(data.error.message);
  throw Error(`Functional error. Read message: ${data.error.message}`);
}

const gasUsed = data.result.gasUsed;
const sender = data.result.from;
const to = data.result.to;

function pad(content) {
  return Buffer.from(
    "0".repeat(66 - content.length) + content.replace("0x", ""),
    "hex"
  );
}

const encodedSender = pad(sender);
const encodedTo = pad(to);
const encodedGasUsed = pad(gasUsed);

return Buffer.concat([encodedSender, encodedTo, encodedGasUsed]);
