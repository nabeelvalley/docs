export const randomInt = (max: number) => Math.floor(Math.random() * max)

export const randomArr = (size: number, max: number) =>
  new Array(size).fill(0).map(() => randomInt(max))

export const withPerf = <T>(label: string, fun: () => T) => {
  const start = performance.now()
  const result = fun()
  const end = performance.now()

  const time = end - start
  console.log(label, time)

  return [result, time]
}

export const sum = (nums: number[]) => nums.reduce((acc, n) => acc + n, 0)

export const average = (nums: number[]) => sum(nums) / nums.length

export const getLgRatio = (nums: number[]) => {
  const lgRatios = nums.slice(1).map((num, i) => Math.log2(num / nums[i]))

  return average(lgRatios)
}

export const getRatio = (nums: number[]) => {
  const ratios = nums.slice(1).map((num, i) => num - nums[i])

  return average(ratios)
}
