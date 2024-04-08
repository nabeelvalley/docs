interface Props {
  css: string
  children?: React.ReactNode
}

export const CSSPreview = (props: Props) => {
  return (
    <>
      {props.children}

      <style dangerouslySetInnerHTML={{ __html: props.css }} />
    </>
  )
}
