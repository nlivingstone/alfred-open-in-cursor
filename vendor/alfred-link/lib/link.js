'use strict';
const fs = require('fs');

const fsP = fs.promises;

module.exports = (src, dest) =>
	fsP
		.rm(dest, {recursive: true, force: true})
		.then(() => fsP.symlink(src, dest));
