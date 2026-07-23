/* eslint-disable indent */
'use strict';
const path = require('path');
const fs = require('fs');
const userHome = require('user-home');
const resolveAlfredPrefs = require('resolve-alfred-prefs');

const fsP = fs.promises;

const idRegexp = /<key>bundleid<\/key>[\s]*<string>(.*?)<\/string>/;

const dirMap = new Map([
	[
		3,
		[
			'Library/Application Support/Alfred 3/Workflow Data',
			'Library/Caches/com.runningwithcrayons.Alfred-3/Workflow Data'
		]
	],
	[
		'default',
		[
			'Library/Application Support/Alfred/Workflow Data',
			'Library/Caches/com.runningwithcrayons.Alfred/Workflow Data'
		]
	]
]);

const removePath = target =>
	fsP.rm(path.join(target), {recursive: true, force: true});

const cleanup = dir =>
	fsP
		.readFile(path.join(dir, 'info.plist'), 'utf8')
		.then(content => idRegexp.exec(content)[1])
		.then(bundleid =>
			resolveAlfredPrefs().then(prefs => {
				const dirs = dirMap.get(prefs.version || 'default');
				return Promise.all(
					dirs.map(dir => removePath(path.join(userHome, dir, bundleid)))
				);
			})
		);

module.exports = dir => cleanup(dir).then(() => removePath(dir));
