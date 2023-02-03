const path = require("path");
const fs = require("fs");
const solc = require("solc");

const outputPath = path.resolve(
  __dirname,
  "..",
  "build",
  "Lock2.bytecode.json"
);

const inputPath = path.resolve(__dirname, "..", "contracts", "Lock2.sol");
const source = fs.readFileSync(inputPath, "utf-8");

var input = {
  language: "Yul",
  sources: {
    "Lock2.sol": {
      content: source,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["evm.bytecode"],
      },
    },
  },
};

const compiledContract = solc.compile(JSON.stringify(input));
console.log(compiledContract);

const bytecode =
  JSON.parse(compiledContract).contracts["Lock2.sol"].Lock2.evm.bytecode.object;
console.log(bytecode);

fs.writeFile(outputPath, JSON.stringify(bytecode), (err) => {});

console.log("Done");
