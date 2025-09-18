#!/bin/bash

# iOS Size Benchmark - Multi-Case Comparison
# This script tests different cases with multiple implementations per language

set -e

# Size calculation factors
TEXT_FACTOR=0.7
DATA_FACTOR=0.2

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_header() {
    echo -e "${CYAN}=========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}=========================================${NC}"
}

count_lines_of_code() {
    local file_path="$1"
    if [ ! -f "$file_path" ]; then
        echo 0
        return
    fi
    
    # Count non-empty, non-comment lines
    # Remove blank lines, lines with only whitespace, and comment-only lines
    local line_count=$(grep -v '^\s*$' "$file_path" | grep -v '^\s*//' | grep -v '^\s*/\*' | grep -v '^\s*\*' | grep -v '^\s*\*/' | wc -l | tr -d ' ')
    echo "$line_count"
}

# Auto-detect Kotlin Native if not set
if [ -z "$KOTLIN_NATIVE_DIST" ]; then
    # Try to find Kotlin Native in common locations
    KOTLIN_CANDIDATES=(
        "/Users/snorlax/.konan/kotlin-native-prebuilt-macos-aarch64-2.2.0"
        "/Users/snorlax/.konan/kotlin-native-prebuilt-macos-aarch64-2.1.10"
        "/usr/local/opt/kotlin-native"
        "/opt/homebrew/opt/kotlin-native"
    )
    
    for candidate in "${KOTLIN_CANDIDATES[@]}"; do
        if [ -f "$candidate/bin/kotlinc-native" ]; then
            export KOTLIN_NATIVE_DIST="$candidate"
            print_info "Auto-detected Kotlin Native at: $KOTLIN_NATIVE_DIST"
            break
        fi
    done
    
    if [ -z "$KOTLIN_NATIVE_DIST" ]; then
        print_warning "KOTLIN_NATIVE_DIST environment variable not set - Kotlin Native compilation will be skipped"
        echo "To enable Kotlin Native compilation, set: export KOTLIN_NATIVE_DIST=/path/to/kotlin-native"
    fi
fi

# Target directories for source files
OBJC_DIR="bazel-workspace/examples/ios-size-benchmark/src/iosMain/objc"
SWIFT_DIR="bazel-workspace/examples/ios-size-benchmark/src/iosMain/swift"
KOTLIN_DIR="bazel-workspace/examples/ios-size-benchmark/src/commonMain/kotlin/kntr/examples/ios/size/benchmark"

mkdir -p "$OBJC_DIR"
mkdir -p "$SWIFT_DIR"
mkdir -p "$KOTLIN_DIR"

clean_build_outputs() {
    print_info "Cleaning previous build outputs..."
    rm -rf bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/ios_size_benchmark_library/prebuild_static_cache/examples_ios-size-benchmark_ios_size_benchmark_library-cache 2>/dev/null || true
}

replace_source_files() {
    local case_name="$1"
    
    # Copy files from simplified structure
    cp "case/$case_name/lib.m" "$OBJC_DIR/lib.m"
    cp "case/$case_name/lib.swift" "$SWIFT_DIR/lib.swift"
    cp "case/$case_name/lib.kt" "$KOTLIN_DIR/IosSizeBenchmark.kt"
}

run_compilation() {
    local case_name="$1"
    
    print_header "COMPILING: $case_name"
    
    # Clean previous builds
    clean_build_outputs
    
    local success_objc=false
    local success_swift=false
    local success_kotlin=false
    
    local text_objc=0
    local text_swift=0
    local text_kotlin=0
    
    local data_objc=0
    local data_swift=0
    local data_kotlin=0
    
    local final_objc=0
    local final_swift=0
    local final_kotlin=0
    
    local lines_objc=0
    local lines_swift=0
    local lines_kotlin=0
    
    # Expected output files
    local OBJC_OUTPUT="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/objc_library/arc/lib.o"
    local SWIFT_OBJECT="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/_objs/swift_library/lib.o"
    local KOTLIN_OUTPUT="bazel-workspace/bazel-out/ios_arm64-opt-ios-arm64-min15.0-applebin_ios-ST-659a08be7a88/bin/examples/ios-size-benchmark/ios_size_benchmark_library/prebuild_static_cache/examples_ios-size-benchmark_ios_size_benchmark_library-cache/bin/libexamples_ios-size-benchmark_ios_size_benchmark_library-cache.a"
    
    # Count lines of code for each language
    lines_objc=$(count_lines_of_code "$OBJC_DIR/lib.m")
    lines_swift=$(count_lines_of_code "$SWIFT_DIR/lib.swift")
    lines_kotlin=$(count_lines_of_code "$KOTLIN_DIR/IosSizeBenchmark.kt")
    
    # Compile Objective-C
    print_info "Compiling Objective-C..."
    if ./compile_objc.sh; then
        if [ -f "$OBJC_OUTPUT" ]; then
            size_output=$(xcrun size -arch arm64 "$OBJC_OUTPUT" | tail -1)
            text_objc=$(echo "$size_output" | awk '{print $1}')
            data_objc=$(echo "$size_output" | awk '{print $2}')
            final_objc=$(echo "$text_objc $data_objc" | awk -v tf="$TEXT_FACTOR" -v df="$DATA_FACTOR" '{printf "%.0f", $1*tf + $2*df}')
            success_objc=true
            print_success "Objective-C compilation successful (Final Size: $final_objc bytes, LOC: $lines_objc)"
        fi
    else
        print_error "Objective-C compilation failed"
    fi
    
    # Compile Swift
    print_info "Compiling Swift..."
    if ./compile_swift.sh; then
        if [ -f "$SWIFT_OBJECT" ]; then
            size_output=$(xcrun size -arch arm64 "$SWIFT_OBJECT" | tail -1)
            text_swift=$(echo "$size_output" | awk '{print $1}')
            data_swift=$(echo "$size_output" | awk '{print $2}')
            final_swift=$(echo "$text_swift $data_swift" | awk -v tf="$TEXT_FACTOR" -v df="$DATA_FACTOR" '{printf "%.0f", $1*tf + $2*df}')
            success_swift=true
            print_success "Swift compilation successful (Final Size: $final_swift bytes, LOC: $lines_swift)"
        else
            print_error "Swift compilation succeeded but object file not found at: $SWIFT_OBJECT"
        fi
    else
        print_error "Swift compilation failed"
    fi
    
    # Compile Kotlin
    print_info "Compiling Kotlin Native..."
    if [ -z "$KOTLIN_NATIVE_DIST" ]; then
        print_warning "Kotlin Native compilation skipped (KOTLIN_NATIVE_DIST not set)"
    elif ./compile_kotlin.sh; then
        if [ -f "$KOTLIN_OUTPUT" ]; then
            size_output=$(xcrun size -arch arm64 "$KOTLIN_OUTPUT" | tail -1)
            text_kotlin=$(echo "$size_output" | awk '{print $1}')
            data_kotlin=$(echo "$size_output" | awk '{print $2}')
            final_kotlin=$(echo "$text_kotlin $data_kotlin" | awk -v tf="$TEXT_FACTOR" -v df="$DATA_FACTOR" '{printf "%.0f", $1*tf + $2*df}')
            success_kotlin=true
            print_success "Kotlin Native compilation successful (Final Size: $final_kotlin bytes, LOC: $lines_kotlin)"
        else
            print_error "Kotlin Native compilation succeeded but output file not found at: $KOTLIN_OUTPUT"
        fi
    else
        print_error "Kotlin Native compilation failed"
    fi
    
    # Store results in a CSV-like format for later analysis
    echo "$case_name,-Os,objc,$success_objc,$text_objc,$data_objc,$final_objc,$lines_objc" >> results.csv
    echo "$case_name,-Os,swift,$success_swift,$text_swift,$data_swift,$final_swift,$lines_swift" >> results.csv
    echo "$case_name,-Os,kotlin,$success_kotlin,$text_kotlin,$data_kotlin,$final_kotlin,$lines_kotlin" >> results.csv
}

discover_and_test_cases() {
    local specific_case="$1"
    
    if [ -n "$specific_case" ]; then
        print_header "RUNNING SPECIFIC CASE: $specific_case"
    else
        print_header "DISCOVERING TEST CASES"
    fi
    
    # Initialize results file
    echo "case,variant,language,success,text_size,data_size,final_size,lines_of_code" > results.csv
    
    # Discover cases - either specific or all
    if [ -n "$specific_case" ]; then
        # Run only the specified case
        if [ ! -d "case/$specific_case" ]; then
            print_error "Case directory not found: case/$specific_case"
            return 1
        fi
        case_dirs=("case/$specific_case")
    else
        # Discover all cases
        case_dirs=(case/*/)
    fi
    
    for case_dir in "${case_dirs[@]}"; do
        if [ ! -d "$case_dir" ]; then
            continue
        fi
        
        case_name=$(basename "$case_dir")
        print_info "Found case: $case_name"
        
        # Check if all required files exist
        if [ ! -f "case/$case_name/lib.m" ] || [ ! -f "case/$case_name/lib.swift" ] || [ ! -f "case/$case_name/lib.kt" ]; then
            print_warning "Skipping $case_name: missing required files (lib.m, lib.swift, lib.kt)"
            continue
        fi
        
        # Replace source files and run compilation
        replace_source_files "$case_name"
        run_compilation "$case_name"
    done
}

generate_summary_report() {
    print_header "BENCHMARK SUMMARY REPORT"
    
    if [ ! -f "results.csv" ]; then
        print_error "No results file found"
        return 1
    fi
    
    echo ""
    echo "Detailed Results:"
    printf "%-20s %-8s %-8s %-10s %-10s %-14s %-8s\n" "Case" "Language" "Success" "Text Size" "Data Size" "Final Size" "LOC"
    printf "%-20s %-8s %-8s %-10s %-10s %-14s %-8s\n" "----" "--------" "-------" "----------" "----------" "----------" "---"
    
    # Skip header line and process results
    tail -n +2 results.csv | while IFS=',' read -r case variant language success text_size data_size final_size lines_of_code; do
        if [ "$success" = "true" ]; then
            status="✓"
        else
            status="✗"
            text_size="N/A"
            data_size="N/A"
            final_size="N/A"
            lines_of_code="N/A"
        fi
        printf "%-20s %-8s %-8s %-10s %-10s %-14s %-8s\n" "$case" "$language" "$status" "$text_size" "$data_size" "$final_size" "$lines_of_code"
    done
    
    echo ""
    echo "Case Comparison Analysis:"
    
    # Analyze each case separately
    for case_name in $(tail -n +2 results.csv | cut -d',' -f1 | sort -u); do
        echo ""
        echo "=== Case: $case_name ==="
        
        # Find smallest final size for this case
        min_size=$(tail -n +2 results.csv | awk -F',' -v case="$case_name" '$1==case && $4=="true" {print $7}' | sort -n | head -1)
        
        if [ -n "$min_size" ] && [ "$min_size" -gt 0 ]; then
            echo "Final Size Analysis (smallest = $min_size bytes, TEXT×${TEXT_FACTOR} + DATA×${DATA_FACTOR}):"
            tail -n +2 results.csv | awk -F',' -v case="$case_name" -v min="$min_size" '
                $1==case && $4=="true" {
                    relative = $7 / min
                    printf "  %-8s: TEXT=%6s DATA=%6s FINAL=%8s bytes (%.2fx) - %s LOC\n", $3, $5, $6, $7, relative, $8
                }
            ' | sort -k2,2n
        fi
    done
}

# Main execution
main() {
    local specific_case=""
    
    # Parse command line arguments
    if [ $# -gt 0 ]; then
        specific_case="$1"
        # Remove "case/" prefix if provided
        specific_case="${specific_case#case/}"
    fi
    
    print_header "iOS Size Benchmark - Multi-Case Analysis"
    
    if [ -n "$specific_case" ]; then
        echo "Running benchmark for specific case: $specific_case"
        echo ""
    else
        echo "This script will:"
        echo "1. Discover all test cases in the 'case/' directory"
        echo "2. Test all combinations of implementation files"
        echo "3. Generate a comprehensive comparison report"
        echo ""
        echo "Usage: $0 [case_name]"
        echo "  case_name: Optional. Run only the specified case (e.g., 'callback' or 'case/callback')"
        echo ""
    fi
    
    discover_and_test_cases "$specific_case"
    generate_summary_report
    
    print_success "Benchmark analysis complete!"
    print_info "Results saved to: results.csv"
}

# Run main function
main "$@"