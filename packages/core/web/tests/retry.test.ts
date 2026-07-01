import { describe, it, expect, vi, beforeEach, afterEach } from "vitest";
import { retry } from "../src";

describe("retry", () => {
  it("returns the value on first success", async () => {
    const result = await retry(() => Promise.resolve(42));
    expect(result).toBe(42);
  });

  it("works with synchronous functions", async () => {
    const result = await retry(() => "hello");
    expect(result).toBe("hello");
  });

  it("retries on failure and succeeds on subsequent attempt", async () => {
    let attempt = 0;
    const result = await retry(
      () => {
        attempt++;
        if (attempt < 3) return Promise.reject(new Error(`fail ${attempt}`));
        return Promise.resolve("ok");
      },
      { maxAttempts: 3, baseDelay: 1 },
    );

    expect(result).toBe("ok");
    expect(attempt).toBe(3);
  });

  it("throws the last error after all attempts are exhausted", async () => {
    await expect(
      retry(() => Promise.reject(new Error("always fails")), {
        maxAttempts: 2,
        baseDelay: 1,
      }),
    ).rejects.toThrow("always fails");
  });

  it("defaults to 3 maxAttempts", async () => {
    let attempt = 0;
    await expect(
      retry(
        () => {
          attempt++;
          return Promise.reject(new Error("fail"));
        },
        { baseDelay: 1 },
      ),
    ).rejects.toThrow("fail");
    expect(attempt).toBe(3);
  });

  describe("exponential backoff timing", () => {
    beforeEach(() => {
      vi.useFakeTimers();
    });

    afterEach(() => {
      vi.useRealTimers();
    });

    it("applies exponential backoff", async () => {
      let attempt = 0;
      const fn = () => {
        attempt++;
        if (attempt <= 3) return Promise.reject(new Error("fail"));
        return Promise.resolve("done");
      };

      const promise = retry(fn, {
        maxAttempts: 4,
        baseDelay: 100,
        multiplier: 2,
      });

      // attempt 1 fails → delay 100ms (100 * 2^0)
      await vi.advanceTimersByTimeAsync(100);
      expect(attempt).toBe(2);

      // attempt 2 fails → delay 200ms (100 * 2^1)
      await vi.advanceTimersByTimeAsync(200);
      expect(attempt).toBe(3);

      // attempt 3 fails → delay 400ms (100 * 2^2)
      await vi.advanceTimersByTimeAsync(400);
      const result = await promise;
      expect(result).toBe("done");
      expect(attempt).toBe(4);
    });

    it("caps delay at maxDelay", async () => {
      let attempt = 0;
      const fn = () => {
        attempt++;
        if (attempt <= 3) return Promise.reject(new Error("fail"));
        return Promise.resolve("done");
      };

      const promise = retry(fn, {
        maxAttempts: 4,
        baseDelay: 100,
        multiplier: 10,
        maxDelay: 500,
      });

      // attempt 1 fails → delay min(100 * 10^0, 500) = 100
      await vi.advanceTimersByTimeAsync(100);
      // attempt 2 fails → delay min(100 * 10^1, 500) = 500
      await vi.advanceTimersByTimeAsync(500);
      // attempt 3 fails → delay min(100 * 10^2, 500) = 500
      await vi.advanceTimersByTimeAsync(500);

      const result = await promise;
      expect(result).toBe("done");
    });
  });

  it("retryIf: retries when predicate returns true", async () => {
    let attempt = 0;
    const result = await retry(
      () => {
        attempt++;
        if (attempt < 2) return Promise.reject(new Error("transient"));
        return Promise.resolve("ok");
      },
      {
        baseDelay: 1,
        retryIf: (err) => (err as Error).message === "transient",
      },
    );
    expect(result).toBe("ok");
  });

  it("retryIf: rethrows immediately when predicate returns false", async () => {
    let attempt = 0;
    await expect(
      retry(
        () => {
          attempt++;
          return Promise.reject(new Error("fatal"));
        },
        {
          maxAttempts: 5,
          baseDelay: 1,
          retryIf: () => false,
        },
      ),
    ).rejects.toThrow("fatal");
    expect(attempt).toBe(1);
  });

  it("maxAttempts = 1 executes once with no retries", async () => {
    let attempt = 0;
    await expect(
      retry(
        () => {
          attempt++;
          return Promise.reject(new Error("fail"));
        },
        { maxAttempts: 1 },
      ),
    ).rejects.toThrow("fail");
    expect(attempt).toBe(1);
  });

  // --- Validation ---

  it("throws RangeError for maxAttempts < 1", async () => {
    await expect(
      retry(() => Promise.resolve(), { maxAttempts: 0 }),
    ).rejects.toThrow(RangeError);
  });

  it("throws RangeError for negative baseDelay", async () => {
    await expect(
      retry(() => Promise.resolve(), { baseDelay: -1 }),
    ).rejects.toThrow(RangeError);
  });

  it("throws RangeError for maxDelay < baseDelay", async () => {
    await expect(
      retry(() => Promise.resolve(), { baseDelay: 100, maxDelay: 50 }),
    ).rejects.toThrow(RangeError);
  });

  it("throws RangeError for multiplier < 1", async () => {
    await expect(
      retry(() => Promise.resolve(), { multiplier: 0.5 }),
    ).rejects.toThrow(RangeError);
  });

  it("throws RangeError for non-integer maxAttempts", async () => {
    await expect(
      retry(() => Promise.resolve(), { maxAttempts: 2.5 }),
    ).rejects.toThrow(RangeError);
  });

  it("accepts baseDelay = 0 (no delay between retries)", async () => {
    let attempt = 0;
    const result = await retry(
      () => {
        attempt++;
        if (attempt < 2) return Promise.reject(new Error("fail"));
        return Promise.resolve("ok");
      },
      { baseDelay: 0, maxDelay: 0 },
    );
    expect(result).toBe("ok");
  });
});
