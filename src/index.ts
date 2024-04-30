import { plugin_completer } from './completer/index';
// import { plugin_editor } from './editor/index';
import { plugin_widget } from './widgets/index';

export * from './version';
export default [
  plugin_completer,
  // plugin_editor,
  plugin_widget
];
