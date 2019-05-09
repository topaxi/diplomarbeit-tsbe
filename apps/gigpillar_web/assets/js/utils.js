/**
 * @template T
 * @template P extends keyof T = keyof T
 * @param {P} key
 * @returns (o: T) => T[P]
 */
export function prop(key) {
  return o => o[key]
}
