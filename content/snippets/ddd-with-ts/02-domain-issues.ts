export type Plank = {
  /** Is this just a string? */
  material: string

  /** Is this some random bit of text? Does it have a structure */
  serialNumber: string

  /** Are there any constraints on this Date? */
  manufacturedDate: Date

  passedQA: boolean

  /** Could we ship something that did not pass QA */
  shipped: boolean
  shippingDate: Date

  /** What units are these measured in? How do we prevent a negative number */
  height: number
  width: number
}
