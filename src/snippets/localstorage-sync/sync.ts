const getValue = <T>(key: string, initial: T) => {
  try {
    const existing = window.localStorage.getItem(key);
    if (!existing) {
      return initial;
    }

    return JSON.parse(existing) as T;
  } catch {
    return initial;
  }
};

const setValue = <T>(key: string, value: T) =>
  window.localStorage.setItem(key, JSON.stringify(value));

export type SetValue<T> = (value: T) => void;

export const createSyncReader = <T>(
  key: string,
  initial: T,
  onChange: (value: T) => void
) => {
  window.addEventListener("storage", () => {
    const value = getValue(key, initial);
    onChange(value);
  });

  return () => getValue(key, initial);
};

export const createSyncWriter =
  <T>(key: string): SetValue<T> =>
  (value) =>
    setValue(key, value);
