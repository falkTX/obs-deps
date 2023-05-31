autoload -Uz log_debug log_error log_info log_status log_output

## Dependency Information
local name='carla'
local version='2.6.0-alpha1'
local url='https://github.com/falkTX/Carla.git'
local hash='f11c6785a369adee5d50bae316ccafc78f03c343'

## Build Steps
setup() {
  log_info "Setup (%F{3}${target}%f)"
  setup_dep ${url} ${hash}
}

clean() {
  cd "${dir}"

  if [[ ${clean_build} -gt 0 && -d "build_${arch}" ]] {
    log_info "Clean build directory (%F{3}${target}%f)"

    rm -rf "build_${arch}"
  }
}

config() {
  autoload -Uz mkcd progress

  log_info "Config (%F{3}${target}%f)"

  args=(
    ${cmake_flags}
    -DCARLA_USE_JACK=OFF
    -DCARLA_USE_OSC=OFF
  )

  cd "${dir}"
  log_debug "CMake configure options: ${args}"
  progress cmake -S cmake -B "build_${arch}" -G Ninja ${args}
}

build() {
  autoload -Uz mkcd

  log_info "Build (%F{3}${target}%f)"

  cd "${dir}"
  cmake --build "build_${arch}" --config "${config}"
}

install() {
  autoload -Uz progress

  log_info "Install (%F{3}${target}%f)"

  args=(
    --install "build_${arch}"
    --config "${config}"
  )

  if [[ "${config}" =~ "Release|MinSizeRel" ]] args+=(--strip)

  cd "${dir}"
  progress cmake ${args}
}