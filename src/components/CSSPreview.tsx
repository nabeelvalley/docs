import type { CSSProperties } from "react";
import { useLayoutEffect } from "react";
import { useRef } from "react";
import { useState } from "react";

import { Pane, type BindingParams } from "tweakpane";

export interface Props {
  css: string;
  children?: React.ReactNode;
  variables: Record<string, BindingParams & { initial: string | number }>;
}

export const CSSPreview = (props: Props) => {
  const id = Math.random().toString().split(".")[1];
  const pane = useRef<Pane>();
  const controls = useRef<HTMLDivElement>(null);

  const initials = Object.keys(props.variables).map((key) => [
    key,
    props.variables[key].initial,
  ]);

  const [tweaks, setTweaks] = useState(Object.fromEntries(initials));

  useLayoutEffect(() => {
    if (!initials.length) {
      return;
    }

    if (!pane.current && controls.current) {
      pane.current = new Pane({
        title: "CSS Variables",
        container: controls.current,
      });

      for (const key in props.variables) {
        const value = props.variables[key];
        const binding = pane.current.addBinding<any, any>(
          { ...tweaks },
          key,
          value
        );

        binding.on("change", (ev) => {
          setTweaks({
            ...tweaks,
            [key]: ev.value,
          });
        });
      }
    }
  });

  const wrappedCSS = `#snippet-${id} { ${props.css} }`;

  return (
    <div id={"snippet-" + id} style={tweaks as CSSProperties}>
      <div style={{ marginBottom: "1rem" }} ref={controls}></div>

      <div>{props.children}</div>

      <style dangerouslySetInnerHTML={{ __html: wrappedCSS }} />
    </div>
  );
};
