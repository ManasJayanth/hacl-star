/* This file was auto-generated by KreMLin! */
#ifndef __Chacha20_vec_H
#define __Chacha20_vec_H



#include "kremlib.h"
#include "testlib.h"
#include "loops_vec.h"
#include "vec32x4N.h"

typedef uint32_t Hacl_Impl_Chacha20_state_u32;

typedef uint32_t Hacl_Impl_Chacha20_state_h32;

typedef uint8_t *Hacl_Impl_Chacha20_state_uint8_p;

typedef vec *Hacl_Impl_Chacha20_state_state;

typedef uint32_t Hacl_Impl_Chacha20_vec_u32;

typedef uint32_t Hacl_Impl_Chacha20_vec_h32;

typedef uint8_t *Hacl_Impl_Chacha20_vec_uint8_p;

typedef uint32_t Hacl_Impl_Chacha20_vec_idx;

typedef struct {
  void *x00;
  void *x01;
}
Hacl_Impl_Chacha20_vec_log_t_;

typedef void *Hacl_Impl_Chacha20_vec_log_t;

void Chacha20_vec_chacha20_key_block(uint8_t *block, uint8_t *k, uint8_t *n, uint32_t ctr);

void Chacha20_vec_double_round(vec *st);

void *Chacha20_vec_value_at(uint8_t *m, FStar_HyperStack_mem h);

void
Chacha20_vec_chacha20(
  uint8_t *output,
  uint8_t *plain,
  uint32_t len,
  uint8_t *k,
  uint8_t *n,
  uint32_t ctr
);

void
Chacha20_vec_crypto_stream_xor_ic(
  uint8_t *output,
  uint8_t *plain,
  uint32_t len,
  uint8_t *n,
  uint8_t *k,
  uint32_t ctr
);
#endif
