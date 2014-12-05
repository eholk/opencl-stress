RUSTC_OPTS = -L$(TARGET_DIR) -O --out-dir $(TARGET_DIR)

opencl-stress: main.rs tester.rs
	$(RUSTC) $(RUSTC_OPTS) main.rs
