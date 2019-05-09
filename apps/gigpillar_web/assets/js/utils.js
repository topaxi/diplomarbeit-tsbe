/**
 * @template T
 * @template P extends keyof T = keyof T
 * @param {P} key
 * @returns {(o: T) => T[P]}
 */
export function prop(key) {
  return o => o[key]
}

/**
 * @template T extends (...args: any[]) => boolean
 * @param {T} fn
 * @return {T}
 */
export function not(fn) {
  return (...args) => !fn(...args)
}

/**
 * @template T
 * @param {T} t
 * @return {<U extends T>(u: U) => u is U}
 */
export const eq = t => u => t === u

/**
 * @template T
 * @template S = T
 * @template U = S
 * @param {Iterable<T>} iterable
 * @param {(value: T) => U} project
 * @param {(value: S) => U} projectValue
 * @return {(value: S) => value is S}
 */
export const includedIn = (
  iterable,
  project = i => i,
  projectValue = project
) => {
  const set = new Set(Array.from(iterable, project))

  return value => set.has(projectValue(value))
}
