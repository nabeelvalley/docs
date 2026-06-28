type Material = 'birch' | 'oak'

type Unit = 'mm' | 'm'

type Dimensions = {
  unit: Unit
  height: number
  width: number
}

type SerialNumber = `${Material}-${number}`

export type Plank = {
  material: Material

  serialNumber: SerialNumber
  manufacturedDate: Date

  passedQA: boolean

  shipped: boolean
  shippingDate: Date

  dimensions: Dimensions
}
