import {
  Tree,
  formatFiles,
  installPackagesTask,
  generateFiles,
  joinPathFragments,
  addDependenciesToPackageJson, updateJson
} from '@nrwl/devkit';
import {getProjectRootPath} from "@nrwl/workspace/src/utilities/project-type";

export interface Schema {
  name: string;
  project: string;
  type: 'api-gateway-v2-proxy-handler-v2';
}

export default async function (tree: Tree, {name, project, type}: Schema) {
  const projectPath = getProjectRootPath(tree, project.replace('/', '-')).replace('/app', '');

  generateFiles(
    tree,
    joinPathFragments(__dirname, `./files/${type}`),
    joinPathFragments(`${projectPath}/functions/${name}`),
    {
      tmpl: ''
    },
  );

  updateDependencies(tree);

  await formatFiles(tree);
  return () => {
    installPackagesTask(tree);
  };
}

function updateDependencies(host: Tree) {
  updateJson(host, 'package.json', (json) => {
    if (json.dependencies && json.dependencies['@types/aws-lambda']) {
      delete json.dependencies['@types/aws-lambda'];
    }
    return json;
  });

  return addDependenciesToPackageJson(
    host,
    {
      '@aws-sdk/client-ssm': '^3.58.0',
      'aws-xray-sdk-core': '^3.3.0',
    },
    {
      '@types/aws-lambda': '^8.10.93',
    }
  );
}
