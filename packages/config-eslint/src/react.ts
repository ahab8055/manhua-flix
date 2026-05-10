import reactPlugin from "eslint-plugin-react";
import reactHooksPlugin from "eslint-plugin-react-hooks";
import tseslint from "typescript-eslint";
import baseConfig from "./base.js";

export default tseslint.config(
  ...baseConfig,
  {
    plugins: {
      react: reactPlugin,
      "react-hooks": reactHooksPlugin,
    },
    rules: {
      ...(reactPlugin.configs.recommended.rules as Record<string, unknown>),
      ...(reactPlugin.configs["jsx-runtime"]?.rules as Record<string, unknown>),
      "react-hooks/rules-of-hooks": "error",
      "react-hooks/exhaustive-deps": "warn",
      "react/prop-types": "off",
    },
    settings: {
      react: { version: "detect" },
    },
  },
);
