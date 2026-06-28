type Unit = 'mm' | 'm'

type Dimensions = {
  unit: Unit
  height: PositiveNumber
  width: PositiveNumber
}

type Option<T> = T | undefined

type PositiveNumber = number & { __brand: 'PositiveNumber' }

const isPositiveNumber = (num: number): num is PositiveNumber => num > 0

const createDimensions = (
  unit: Unit,
  height: number,
  width: number
): Option<Dimensions> => {
  if (isPositiveNumber(height) && isPositiveNumber(width)) {
    return { unit, height, width }
  }

  return undefined
}
