import {
  Tree,
  formatFiles,
  installPackagesTask,
  getWorkspaceLayout,
  generateFiles, joinPathFragments
} from '@nrwl/devkit';
import {applicationGenerator} from '@nrwl/node';
import {replace} from "@phenomnomnominal/tsquery/dist/src/replace";
import {query} from "@phenomnomnominal/tsquery/dist/src/query";

export interface Schema {
  name: string;
  type: 'lambda' | 'lambdaAtEdge' | 'cloudfront';
}

export default async function (tree: Tree, {name, type}: Schema) {
  const {appsDir} = getWorkspaceLayout(tree);
  const projectPath = `${appsDir}/${name}`;
  const projectSrcPath = `${projectPath}/src`;

  await applicationGenerator(tree, {name});

  tree.delete(`${projectSrcPath}/assets`);
  tree.rename(`${projectSrcPath}/app/.gitkeep`, `${projectSrcPath}/functions/.gitkeep`);
  const environmentText = tree.read(`${projectSrcPath}/environments/environment.ts`);
  tree.write(`${projectSrcPath}/environments/environment.dev.ts`, environmentText);

  let projectText = tree.read(`${projectPath}/project.json`).toString();

  projectText = replace(
    projectText,
    'ExpressionStatement:has([value=assets]) ~ ExpressionStatement',
    () => `"${appsDir}/${name}/webpack.config.js"`
  );
  projectText = replace(
    projectText,
    '[value=assets]',
    () => '"webpackConfig"'
  );
  const [productionBlock] = query(projectText, 'ExpressionStatement:has([value=production]) ~ Block');
  const productionNodeText = projectText.substring(productionBlock.pos, productionBlock.end);

  const [productionNode] = query(projectText, '[value=production]');
  const {pos} = trimNode(projectText, productionNode);
  projectText = insertAt(
    projectText,
    `"development": ${productionNodeText.replace('.prod', '.dev')},\n${' '.repeat(pos - productionNode.pos - 1)}`,
    pos,
  );

  tree.write(`${projectPath}/project.json`, projectText);

  await formatFiles(tree);

  generateFiles(
    tree,
    joinPathFragments(__dirname, `./files`),
    joinPathFragments(`./${projectPath}`),
    {type, tmpl: ''}
  );

  return () => {
    installPackagesTask(tree);
  };
}

const insertAt = (a,b,position) => {
  return a.substring(0, position) + b + a.substring(position)
}

const trimNode = (str, {pos, end}) => {
  const subStr = str.substring(pos, end);
  const trimStr = subStr.trim();
  if (trimStr.length === subStr.length) {
    return {pos, end};
  }
  const offsetPos = subStr.search(trimStr);
  return {pos: pos + offsetPos, end: pos + offsetPos + trimStr.length};
}
