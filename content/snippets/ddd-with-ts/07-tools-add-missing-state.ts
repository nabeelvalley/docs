type Material = 'birch' | 'oak'

type Unit = 'mm' | 'm'

type Dimensions = {
  unit: Unit
  height: number
  width: number
}

type SerialNumber = `${Material}-${number}`

type Status =
  | {
      status: 'qa-needed'
    }
  | {
      status: 'scrapped'
    }
  | {
      status: 'ready-for-shipping'
      shipped: boolean
      shippingDate: Date
    }

export type Plank = Status & {
  material: Material

  serialNumber: SerialNumber
  manufacturedDate: Date

  dimensions: Dimensions
}
