import { useState } from 'react'

export const Contact = () => {
  const [visible, setVisible] = useState(false)

  console.log(import.meta)

  if (!visible) {
    return (
      <div className="contact">
        <button
          type="button"
          onClick={() => setVisible(true)}
          className="button"
        >
          Show contact details
        </button>
      </div>
    )
  }

  return (
    <div className="contact">
      <p>
        <a href={`tel:${import.meta.env.PUBLIC_CONTACT_PHONE}`}>
          {import.meta.env.PUBLIC_CONTACT_PHONE}
        </a>
      </p>
      <p>
        <a href={`mailto:${import.meta.env.PUBLIC_CONTACT_EMAIL}`}>
          {import.meta.env.PUBLIC_CONTACT_EMAIL}
        </a>
      </p>
    </div>
  )
}
