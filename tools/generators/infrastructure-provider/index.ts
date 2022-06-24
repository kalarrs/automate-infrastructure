import {Tree, formatFiles, installPackagesTask, generateFiles, joinPathFragments} from '@nrwl/devkit';

export interface Schema {
  name: string;
}

export default async function (tree: Tree, {name}: Schema) {
  generateFiles(
    tree,
    joinPathFragments(__dirname, `./files/${name}`),
    joinPathFragments(`./infrastructure/${name}`),
    {},
  );

  await formatFiles(tree);
  return () => {
    installPackagesTask(tree);
  };
}
