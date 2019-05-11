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
 * @template T
 * @param {(o: T) => T[keyof T]} project
 * @param {T[keyof T]} value
 * @return {(o: T) => boolean}
 */
export function by(project, value) {
  return o => project(o) === value
}

/**
 * @template T extends (...args: any[]) => boolean
 * @param {T} fn
 * @return {(...args: any[]) => boolean}
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

/**
 * @param {string | Date | null} dateStr
 * @return {Date | null}
 */
export function dateConverter(dateStr) {
  if (dateStr instanceof Date) return dateStr
  if (!dateStr) return null

  return new Date(Date.parse(dateStr))
}
