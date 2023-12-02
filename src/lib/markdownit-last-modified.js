import { execSync } from "child_process";

const format = new Intl.DateTimeFormat('en-GB', {
  day: '2-digit',
  month: 'long',
  year: 'numeric'
}).format

export const remarkModifiedTime = () => {
  return function (tree, file) {
    const filepath = file.history[0];
     try {
       const lastModified = execSync(`git log -1 --pretty="format:%cI" ${filepath}`);
       const formatted = format(new Date(lastModified))
       file.data.astro.frontmatter.lastModified = formatted
      } catch {
        console.log("Unable to get lastModified data for file", file)
      }
  };
}