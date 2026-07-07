
/**
 * @param {string | number | Date} date
 */
export function toRFC822(date){
  return new Date(date).toUTCString()
}
