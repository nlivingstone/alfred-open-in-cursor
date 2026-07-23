'use strict';

/**
 * standard-version updater for the workflow version in info.plist.
 * Only updates the root <string> semver, not Alfred object version integers.
 */
module.exports.readVersion = function readVersion(contents) {
  const matches = [...contents.matchAll(/<key>version<\/key>\s*<string>([^<]+)<\/string>/g)];
  return matches.length > 0 ? matches[matches.length - 1][1] : null;
};

module.exports.writeVersion = function writeVersion(contents, version) {
  const lines = contents.split('\n');
  let lastVersionLineIndex = -1;

  for (let index = 0; index < lines.length; index++) {
    if (lines[index].includes('<key>version</key>') && lines[index + 1]?.includes('<string>')) {
      lastVersionLineIndex = index + 1;
    }
  }

  if (lastVersionLineIndex === -1) {
    throw new Error('Could not find workflow version in info.plist');
  }

  lines[lastVersionLineIndex] = lines[lastVersionLineIndex].replace(
    /<string>[^<]+<\/string>/,
    `<string>${version}</string>`,
  );

  return lines.join('\n');
};
