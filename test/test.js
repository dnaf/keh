const util = require("util");

const assert = require("assert");
const keh = require("..");
const readFile = util.promisify(require("fs").readFile);

it("should work", async function() {
	let input = readFile("./test/sample.keh", { encoding: "utf8" });
	let expected = readFile("./test/output.json", { encoding: "utf8" });

	assert.deepStrictEqual(keh.parse(await input), JSON.parse(await expected));
});
