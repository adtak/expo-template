// Using .js instead of .ts because jest-expo uses babel-jest, and
// .ts config requires ts-node as an extra dependency. Not worth adding
// a dependency just for type-checking a small config file.
/** @type {import('jest').Config} */
const config = {
  preset: "jest-expo",
  moduleNameMapper: {
    "^@/(.*)$": "<rootDir>/$1",
  },
  setupFilesAfterEnv: [
    "@testing-library/react-native/build/matchers/extend-expect",
  ],
};

module.exports = config;
