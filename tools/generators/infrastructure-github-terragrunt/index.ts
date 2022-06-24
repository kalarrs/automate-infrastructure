import {Tree, formatFiles, installPackagesTask, generateFiles, joinPathFragments} from '@nrwl/devkit';

export interface Schema {
  name: string;
  profile: string;
  stage: string;
  environment: string | null;
  region: string;
  module: string;
  hasDependencies: boolean;
  hasNestedModules: boolean;
}

export default async function (tree: Tree, {
  name,
  profile,
  stage,
  environment,
  region,
  module,
  hasDependencies,
  hasNestedModules
}: Schema) {
  const isEnv = environment?.length > 1;
  const stageOrEnvironmentName = isEnv ? `${stage}-${environment}` : stage;
  const type = isEnv ? 'environments' : 'stages';

  const tmpl = '';

  generateFiles(
    tree,
    joinPathFragments(__dirname, `./files`),
    joinPathFragments(`./infrastructure/aws/${profile}/${type}/${stageOrEnvironmentName}/${region}/${name}`),
    {module, hasDependencies, hasNestedModules, tmpl}
  );

  await formatFiles(tree);
  return () => {
    installPackagesTask(tree);
  };
}
