type Dimensions = {
  height: number
  width: number
}

export type Plank = {
  material: string

  serialNumber: string
  manufacturedDate: Date

  passedQA: boolean

  shipped: boolean
  shippingDate: Date

  dimensions: Dimensions
}
