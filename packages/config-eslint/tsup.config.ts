import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/base.ts", "src/react.ts", "src/nestjs.ts"],
  format: ["cjs", "esm"],
  dts: true,
  clean: true,
  outDir: "dist",
});
