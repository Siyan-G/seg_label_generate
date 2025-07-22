PROJECT_NAME:= seg_label_generate

# config ----------------------------------

INCLUDE_DIRS := include
LIBRARY_DIRS := lib

COMMON_FLAGS := -DCPU_ONLY
CXXFLAGS := -std=c++11 -fopenmp
LDFLAGS := -fopenmp -Wl,-rpath,./lib

# Use pkg-config for OpenCV 4
OPENCV_FLAGS := $(shell pkg-config --cflags --libs opencv4)

# Add OPENCV_FLAGS to CXXFLAGS and LDFLAGS accordingly
# pkg-config --cflags includes -I/usr/include/opencv4
CXXFLAGS += $(COMMON_FLAGS) $(foreach includedir,$(INCLUDE_DIRS),-I$(includedir)) $(shell pkg-config --cflags opencv4)
LDFLAGS += $(COMMON_FLAGS) $(foreach includedir,$(LIBRARY_DIRS),-L$(includedir)) $(shell pkg-config --libs opencv4)

SRC_DIRS += $(shell find * -type d -exec bash -c "find {} -maxdepth 1 \( -name '*.cpp' -o -name '*.proto' \) | grep -q ." \; -print)
CXX_SRCS += $(shell find src/ -name "*.cpp")
CXX_TARGETS:=$(patsubst %.cpp, $(BUILD_DIR)/%.o, $(CXX_SRCS))
ALL_BUILD_DIRS := $(sort $(BUILD_DIR) $(addprefix $(BUILD_DIR)/, $(SRC_DIRS)))

.PHONY: all
all: $(PROJECT_NAME)

.PHONY: $(ALL_BUILD_DIRS)
$(ALL_BUILD_DIRS):
	@mkdir -p $@

$(BUILD_DIR)/%.o: %.cpp | $(ALL_BUILD_DIRS)
	@echo "CXX" $<
	@$(CXX) $(CXXFLAGS) -c -o $@ $<

$(PROJECT_NAME): $(CXX_TARGETS)
	@echo "CXX/LD" $@
	@$(CXX) -o $@ $^ $(LDFLAGS)

.PHONY: clean
clean:
	@rm -rf $(CXX_TARGETS)
	@rm -rf $(PROJECT_NAME)
	@rm -rf $(BUILD_DIR)
