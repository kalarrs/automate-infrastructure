import {resolve} from 'path';
import {exec as execCallback} from 'child_process';
import {promisify} from "util";
import {readdir} from "fs/promises";

const exec = promisify(execCallback);

const webpackConfig = (maxMb, isNode = true) => ({dirName}) => async (config, {options: {optimization}}) => {
  const {entry: {main}, output} = config;
  const functions = (await readdir(`${dirName}/src/functions`, { withFileTypes: true }))
    .filter(i => i.isDirectory())
    .map(d => d.name);
  const functionEntry = isNode
    ? Object.fromEntries(functions.map((f) => [`functions/${f}/index`, resolve(dirName, `./src/functions/${f}/index.ts`)]))
    : {};

  const maxLambdaAtEdgeSize = 1048576 * maxMb;
  const maxAssetSize = optimization ? maxLambdaAtEdgeSize : maxLambdaAtEdgeSize * 1.5;
  const maxEntrypointSize = optimization ? maxLambdaAtEdgeSize : maxLambdaAtEdgeSize * 1.5;

  const local = function (context, request, callback) {
    if (/^@local/.test(request)) {
      callback(null, `commonjs ${request.replace('@local', './functions/')}`);
      return;
    }
    callback();
  };

  if (!isNode) {
    await exec('tsc -b', {cwd: dirName});
  }

  return {
    ...config,
    entry: {...functionEntry, main},
    output: {...output, filename: '[name].js'},
    externals: [
      /^aws-sdk/,
      local,
    ],
    performance: {hints: 'error', maxAssetSize, maxEntrypointSize},
    optimization: {minimize: optimization, usedExports: true},
  };
};

export const lambdaAtEdge = webpackConfig(1);
export const lambda = webpackConfig(40);
export const cloudfront = webpackConfig(1, false);
